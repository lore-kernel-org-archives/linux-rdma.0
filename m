From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: Kernel and User Libraries Patch
Date: Mon, 25 Jul 2011 09:22:45 +0000
Message-ID: <CD250C48050CFB4D95E78C95F2FDDD6E13A4A90F@MTLDAG01.mtl.com>
References: <DF5E339AC1B1EB40B8C0E673B245B1DE91C453C1E7@MAILBOXCLUSTER.datadirect.datadirectnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DF5E339AC1B1EB40B8C0E673B245B1DE91C453C1E7-swl+H887UHg+pwU0QB3UJFCcJpiHUltuuLF6cSL8SQ0BCtbi0EFk9UEOCMrvLtNR@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavan Uppu <puppu-LfVdkaOWEx8@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> I work DataDirect Networks Inc. and have been working with SRP target=
 driver using OFED=A0 kernel and=A0 user libraries.=20
> I had to patch some kernel and user libraries to export a verb =91ib_=
modify_port=92 to user space as SRP target driver requires it.=20
> Wanted to check if this patch can be applied to the OFED Code for fut=
ure releases and if yes, what would be the procedure to follow ?

Hi Pavan
The process is to submit the patches to the linux-rdma list (linux-rdma=
@vger.kernel.org)
Since its related to SRP you should mail it to SRP maintainer David Dil=
low <dillowda-1Heg1YXhbW8@public.gmane.org>
After this is accepted by the kernel you can submit the patches to OFED=
 with the relevant backport patches

Regards,
Tziporet
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
