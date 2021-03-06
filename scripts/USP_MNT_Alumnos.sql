
USE [Examen]
GO
/****** Object:  StoredProcedure [dbo].[USP_MNT_Alumnos]    Script Date: 08/06/2022 14:48:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[USP_MNT_Alumnos]    Script Date: 26/01/2022 19:35:58 ******/

	CREATE PROCEDURE [dbo].[USP_MNT_Alumnos]          
            
	@sOpcion VARCHAR(2) = '',   
	@pParametro VARCHAR(max)
                                                                                   
AS     

BEGIN

	BEGIN
		
		DECLARE @IdAlumno  INT;
		DECLARE @sCodAlu	  VARCHAR(MAX);
		DECLARE @sNombrePri		VARCHAR(MAX);		
		DECLARE @sNombreSec		VARCHAR(MAX);		
		DECLARE @sApellidoPaterno	VARCHAR(MAX);
		DECLARE @sApellidoMaterno	VARCHAR(MAX);
		DECLARE @dFechaNacimiento	DATE;
		DECLARE @sSexo	VARCHAR(10);
		DECLARE @bEstado	BIT;
						
		DECLARE @Correlativo INT;
				
	END
	
	--VARIABLE TABLA
	BEGIN

		DECLARE @tParametro TABLE (
			id int,
			valor varchar(max)
		);

	END

	--Descontena el parametro con split
	BEGIN
		IF(LEN(LTRIM(RTRIM(@pParametro))) > 0)
			BEGIN
			    INSERT INTO @tParametro (id, valor ) SELECT id, valor FROM dbo.Split(@pParametro, '|');
			END;
	END;
        
		
	IF @sOpcion = '01'   --CONSULTAR REGISTRO DE CODIGOS
	BEGIN
			
			SELECT
				*
			FROM AP_Murga_Jose_Alumno
			                                                                                 
	END;                         

  ELSE IF @sOpcion = '02'   --CONSULTAR REGISTRO DE CODIGOS
	BEGIN
		BEGIN
			SET @IdAlumno	= (SELECT valor FROM @tParametro WHERE id = 1);
		END

    BEGIN
		SELECT
			IdAlumno,
			TRIM(sCodAlu) AS 'sCodAlu',
			sNombrePri,
			sNombreSec,
			sApellidoPaterno,
			sApellidoMaterno,
			dFechaNacimiento,
			CONVERT(VARCHAR, dFechaNacimiento,23) AS 'dFechaNac',
			TRIM(sSexo) AS 'sSexo',
			bEstado
		FROM [AP_Murga_Jose_Alumno]
		WHERE 
			IdAlumno = @IdAlumno
    END
						                                                                                 
	END;

	ELSE IF @sOpcion = '03'  --INSERT
		BEGIN
			BEGIN
				SET @sNombrePri	= (SELECT valor FROM @tParametro WHERE id = 1);
				SET @sNombreSec	= (SELECT valor FROM @tParametro WHERE id = 2);
				SET @sApellidoPaterno	= (SELECT valor FROM @tParametro WHERE id = 3);
				SET @sApellidoMaterno	= (SELECT valor FROM @tParametro WHERE id = 4);
				SET @dFechaNacimiento	= (SELECT valor FROM @tParametro WHERE id = 5);
				SET @sSexo				= (SELECT valor FROM @tParametro WHERE id = 6);
								
				SELECT @Correlativo = ISNULL(MAX(IdAlumno), 0) + 1 FROM [AP_Murga_Jose_Alumno];

		  END	
      
		  BEGIN
    	
				  SELECT @sCodAlu = 'ALU'+right('0000' + convert(varchar(5), @Correlativo), 5)
					
				  INSERT INTO [AP_Murga_Jose_Alumno]
							(sCodAlu,  sNombrePri,  sNombreSec,  sApellidoPaterno,  sApellidoMaterno,  dFechaNacimiento,  sSexo, bEstado)
				  VALUES	(@sCodAlu, @sNombrePri, @sNombreSec, @sApellidoPaterno, @sApellidoMaterno, @dFechaNacimiento, @sSexo, 1)

				  SELECT CONCAT('1|',@sCodAlu)
		  		
		  END
		
	  END
	   
	   
	ELSE IF @sOpcion = '04'  -- ACTUALIZAR
		BEGIN
			BEGIN
			  
				SET @sNombrePri	= (SELECT valor FROM @tParametro WHERE id = 1);
				SET @sNombreSec	= (SELECT valor FROM @tParametro WHERE id = 2);
				SET @sApellidoPaterno	= (SELECT valor FROM @tParametro WHERE id = 3);
				SET @sApellidoMaterno	= (SELECT valor FROM @tParametro WHERE id = 4);
				SET @dFechaNacimiento	= (SELECT valor FROM @tParametro WHERE id = 5);
				SET @sSexo				= (SELECT valor FROM @tParametro WHERE id = 6);

				SET @IdAlumno	= (SELECT valor FROM @tParametro WHERE id = 7);

				SELECT @sCodAlu = sCodAlu FROM [AP_Murga_Jose_Alumno] WHERE IdAlumno = @IdAlumno
		 
			END	
		
		BEGIN
			UPDATE [AP_Murga_Jose_Alumno]
			SET 
				sNombrePri = @sNombrePri,
				sNombreSec = @sNombreSec,
				sApellidoPaterno = @sApellidoPaterno,
				sApellidoMaterno = @sApellidoMaterno,
				dFechaNacimiento = @dFechaNacimiento,
				sSexo = @sSexo				
			WHERE 
				IdAlumno = @IdAlumno

			SELECT CONCAT('1|El Alumno con código ',@sCodAlu,' se actualizó con éxito')
		END
	
        
	  END;

  ELSE IF @sOpcion = '05'  -- ELIMINAR/ACTIVAR
		BEGIN
			BEGIN
				SET @IdAlumno	= (SELECT valor FROM @tParametro WHERE id = 1);
				SET @bEstado	= (SELECT valor FROM @tParametro WHERE id = 2);
				
				SELECT @sCodAlu = sCodAlu FROM [AP_Murga_Jose_Alumno] WHERE IdAlumno = @IdAlumno
		  END	
		
			  BEGIN

					UPDATE [AP_Murga_Jose_Alumno]
					SET 
						bEstado = @bEstado
					WHERE 
						IdAlumno = @IdAlumno
                           
				  SELECT CONCAT('1|El Alumno con código ',@sCodAlu,' ha Sido Eliminado')
			  END
	
        
	  END;
	
END

