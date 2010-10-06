From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] [PATCH] ibdiagpath: Properly index VlArbTable during QoS
 test
Date: Wed, 06 Oct 2010 17:30:40 +0200
Message-ID: <4CAC9620.9060609@dev.mellanox.co.il>
References: <4C8F9617.8010400@novell.com>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C8F9617.8010400-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Jolly <jjolly-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Cc: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14-Sep-10 5:34 PM, John Jolly wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Description: ibdiagpath: Properly index VlArbTable during QoS test
> Symptom:     Error 'invalid bareword "vl_entry"' during "QoS on
>               Path Check"
> Problem:     The 'dump' command within the smVlArbTableMad command
>               appends '-vl_entry' to the beginning of the array.
>               The ibdebug.tcl script does not properly handle this
>               extra element at the beginning of the array.
> Solution:    Offset the index value by one when referencing the
>               array.
> Problem-ID:  629166
> - ---

Thanks, applied.

-- YK
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
