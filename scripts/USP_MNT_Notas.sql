USE [Examen]
GO
/****** Object:  StoredProcedure [dbo].[USP_MNT_Notas]    Script Date: 08/06/2022 14:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_MNT_Notas]          
            
	@sOpcion VARCHAR(2) = '',   
	@pParametro VARCHAR(max)
                                                                                   
AS     

BEGIN

	BEGIN
		
		DECLARE @IdNotas	INT;
		DECLARE @IdAlumno	INT;
		DECLARE @IdCurso	INT;
		DECLARE @nPractica1		DECIMAL(4,2);
		DECLARE @nPractica2		DECIMAL(4,2);
		DECLARE @nPractica3		DECIMAL(4,2);
		DECLARE @nParcial		DECIMAL(4,2);
		DECLARE @nFinal			DECIMAL(4,2);
		DECLARE @nPromedioFinal	DECIMAL(4,2);


		DECLARE @sCodAlu	VARCHAR(MAX);		
		DECLARE @sNomAlu	VARCHAR(MAX);		
		DECLARE @sNomCur	VARCHAR(MAX);		
    		
				
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
        		
	IF @sOpcion = '01'   --CONSULTAR POR CODIGO
	BEGIN
		BEGIN
			SET @sCodAlu	= (SELECT valor FROM @tParametro WHERE id = 1);
		END
		
		SELECT
			IdNotas
			,Alu.IdAlumno
			,CONCAT(TRIM(Alu.sNombrePri), ' ', IIF(TRIM(Alu.sNombreSec) = '', '', CONCAT(TRIM(Alu.sNombreSec), ' ')), 
				TRIM(Alu.sApellidoPaterno), ' ', TRIM(Alu.sApellidoMaterno)) AS 'sNombreAlumno'
			,Cur.IdCurso			
			,Cur.sNombre AS 'sNombreCurso'
			,AluCur.nPractica1		AS 'nPractica1'
			,AluCur.nPractica2		AS 'nPractica2'
			,AluCur.nPractica3		AS 'nPractica3'
			,AluCur.nParcial		AS 'nParcial'
			,AluCur.nFinal			AS 'nFinal'
			,AluCur.nPromedioFinal	AS 'nPromedioFinal'
			,AluCur.bEstado AS 'bEstado'
		FROM [dbo].[AP_Murga_Jose_Notas] AluCur
		INNER JOIN [dbo].[AP_Murga_Jose_Alumno] AS Alu ON AluCur.IdAlumno = Alu.IdAlumno AND Alu.bEstado = 1
		INNER JOIN [dbo].[AP_Murga_Jose_Curso] AS Cur ON AluCur.IdCurso = Cur.IdCurso AND Cur.bEstado = 1
		WHERE
			sCodAlu = @sCodAlu
			AND AluCur.bEstado = 1

			                                                                                 
	END;                         

	ELSE IF @sOpcion = '02'   --CONSULTAR EXISTENTE
	BEGIN
    BEGIN
		SET @IdAlumno	= (SELECT valor FROM @tParametro WHERE id = 1);
		SET @IdCurso	= (SELECT valor FROM @tParametro WHERE id = 2);

    END

    BEGIN
		SELECT
			IdNotas
			,Alu.IdAlumno
			,CONCAT(TRIM(Alu.sNombrePri), ' ', IIF(TRIM(Alu.sNombreSec) = '', '', CONCAT(TRIM(Alu.sNombreSec), ' ')), 
				TRIM(Alu.sApellidoPaterno), ' ', TRIM(Alu.sApellidoMaterno)) AS 'sNombreAlumno'
			,Cur.IdCurso			
			,Cur.sNombre AS 'sNombreCurso'
			,AluCur.nPractica1		AS 'nPractica1'
			,AluCur.nPractica2		AS 'nPractica2'
			,AluCur.nPractica3		AS 'nPractica3'
			,AluCur.nParcial		AS 'nParcial'
			,AluCur.nFinal			AS 'nFinal'
			,AluCur.nPromedioFinal	AS 'nPromedioFinal'
			,AluCur.bEstado AS 'bEstado'
		FROM [dbo].[AP_Murga_Jose_Notas] AluCur
		INNER JOIN [dbo].[AP_Murga_Jose_Alumno] AS Alu ON AluCur.IdAlumno = Alu.IdAlumno AND Alu.bEstado = 1
		INNER JOIN [dbo].[AP_Murga_Jose_Curso] AS Cur ON AluCur.IdCurso = Cur.IdCurso AND Cur.bEstado = 1
		WHERE
			Alu.IdAlumno = @IdAlumno
			AND Cur.IdCurso = @IdCurso
			AND AluCur.bEstado = 1

    END
						                                                                                 
	END;

	ELSE IF @sOpcion = '03'  --INSERT
	BEGIN
		  BEGIN
			SET @IdAlumno	= (SELECT valor FROM @tParametro WHERE id = 1);
			SET @IdCurso	= (SELECT valor FROM @tParametro WHERE id = 2);
			SET @nPractica1		  = (SELECT valor FROM @tParametro WHERE id = 3);
			SET @nPractica2		  = (SELECT valor FROM @tParametro WHERE id = 4);
			SET @nPractica3		  = (SELECT valor FROM @tParametro WHERE id = 5);
			SET @nParcial		  = (SELECT valor FROM @tParametro WHERE id = 6);
			SET @nFinal			  = (SELECT valor FROM @tParametro WHERE id = 7);
			SET @nPromedioFinal  = (SELECT valor FROM @tParametro WHERE id = 8);
			
		  END	

		  BEGIN
    						
				  INSERT INTO [AP_Murga_Jose_Notas]
							(IdAlumno, IdCurso ,   nPractica1,  nPractica2,  nPractica3,  nParcial,  nFinal,  nPromedioFinal, bEstado)
				  VALUES	(@IdAlumno, @IdCurso , @nPractica1, @nPractica2, @nPractica3, @nParcial, @nFinal, @nPromedioFinal, 1)

				  SELECT CONCAT('1|','Sé Agregó la nota correctamente ')
		  		
		  END
		
	  END
	   	   
	ELSE IF @sOpcion = '04'  -- ACTUALIZAR
	BEGIN
      BEGIN			
			SET @IdAlumno	= (SELECT valor FROM @tParametro WHERE id = 1);
			SET @IdCurso	= (SELECT valor FROM @tParametro WHERE id = 2);
			SET @nPractica1		  = (SELECT valor FROM @tParametro WHERE id = 3);
			SET @nPractica2		  = (SELECT valor FROM @tParametro WHERE id = 4);
			SET @nPractica3		  = (SELECT valor FROM @tParametro WHERE id = 5);
			SET @nParcial		  = (SELECT valor FROM @tParametro WHERE id = 6);
			SET @nFinal			  = (SELECT valor FROM @tParametro WHERE id = 7);
			SET @nPromedioFinal  = (SELECT valor FROM @tParametro WHERE id = 8);

		  END	
		
			  BEGIN
			    UPDATE [AP_Murga_Jose_Notas]                           
				  SET 
					  nPractica1		= @nPractica1	,
					  nPractica2		= @nPractica2	,       
					  nPractica3		= @nPractica3	,       
					  nParcial			= @nParcial		,       
					  nFinal			= @nFinal		,       
					  nPromedioFinal	= @nPromedioFinal
				  WHERE 
						IdAlumno = @IdAlumno
						AND IdCurso = @IdCurso

				  SELECT '1|Se modificó la nota con éxito'
			  END
	
        
	  END;

  ELSE IF @sOpcion = '05'  -- ELIMINAR
	BEGIN
		BEGIN
			SET @IdNotas	= (SELECT valor FROM @tParametro WHERE id = 1);
		END	
		
		BEGIN

			UPDATE [AP_Murga_Jose_Notas]                           
				  SET 
					  bEstado = 0
				  WHERE 
						IdAlumno = @IdAlumno
						AND IdCurso = @IdCurso
            
			SELECT '1|Se eliminó la nota con éxito'
		END
	
        
	  END;
	
END

