#tag Class
Protected Class Stopwatch_MTC
	#tag Method, Flags = &h0
		Sub Constructor()
		  // By callling Start/Stop/Reset now, it makes subsequent calls faster, compensating for the method calls
		  
		  me.Start
		  me.Stop
		  me.Reset
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsRunning() As Boolean
		  return zRunning
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Lap()
		  #pragma BackgroundTasks False
		  
		  if zRunning then
		    zLaps.Append Microseconds - zStartMS
		    zAverageLapMSCalculated = false
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  zRunning = false
		  zStartMS = 0.
		  zStopMS = 0.
		  redim zLaps( -1 )
		  redim zLaps( 0 ) // Start with zero
		  
		  zAverageLapMS = 0.
		  zAverageLapMSCalculated = false
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Start()
		  #pragma BackgroundTasks False
		  
		  if not zRunning then
		    zStartMS = zStartMS + ( Microseconds - zStopMS ) // Compensate for any pauses
		    zRunning = true
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Stop()
		  #pragma BackgroundTasks False
		  
		  dim ms as Double = microseconds
		  
		  if zRunning then
		    zStopMS = ms
		    zRunning = false
		  end if
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #pragma BackgroundTasks False
			  
			  dim r as double
			  
			  if zAverageLapMSCalculated then
			    
			    r = zAverageLapMS
			    
			  else
			    
			    for i as integer = 1 to zLaps.Ubound // The zero element is a zero
			      r = r + ( zLaps( i ) - zLaps( i - 1 ) )
			    next
			    
			    r = r / ( zLaps.Ubound + 1 )
			    
			    zAverageLapMS = r
			    zAverageLapMSCalculated = true
			    
			  end if
			  
			  return r
			  
			End Get
		#tag EndGetter
		AverageLapMicroseconds As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return AverageLapMicroseconds / 1000.
			  
			End Get
		#tag EndGetter
		AverageLapMilliseconds As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return AverageLapMicroseconds / 1000000.
			  
			End Get
		#tag EndGetter
		AverageLapSeconds As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim r as double
			  if zRunning then
			    r = microseconds - zStartMS
			  else
			    r = zStopMS - zStartMS
			  end if
			  
			  return r
			  
			End Get
		#tag EndGetter
		ElapsedMicroseconds As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return ElapsedMicroseconds / 1000.
			  
			End Get
		#tag EndGetter
		ElapsedMilliseconds As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return ElapsedMicroseconds / 1000000.
			  
			End Get
		#tag EndGetter
		ElapsedSeconds As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private zAverageLapMS As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zAverageLapMSCalculated As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zLaps(0) As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zRunning As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zStartMS As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zStopMS As Double
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="AverageLapMicroseconds"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AverageLapMilliseconds"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AverageLapSeconds"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ElapsedMicroseconds"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ElapsedMilliseconds"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ElapsedSeconds"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
