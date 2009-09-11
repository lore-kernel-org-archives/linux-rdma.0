From: Barry Mavin <Barry.Mavin-sPOXD9PnZXtBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
 'ibcheckspeed' and 'ibcheckportspeed' to scripts
Date: Fri, 11 Sep 2009 11:43:40 +0530
Message-ID: <C6CFE86C.15626%Barry.Mavin@recital.com>
References: <829ded920909102246o18b25caagf84bfe352f699a82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <829ded920909102246o18b25caagf84bfe352f699a82-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OFED mailing list <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When I start the subnet manager on redhat 5.3 with:

# service opensm restart

I get the following messages in the log file.

Sep 11 11:41:46 252576 [4EF83940] 0x01 -> __osm_mcmr_rcv_join_mgrp: ERR
1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState = 0
failed from port 0x0002c90300047b91 (ibas1 HCA-1), sending
IB_SA_MAD_STATUS_REQ_INVALID
Sep 11 11:41:46 252688 [4EF83940] 0x01 -> __osm_mcmr_rcv_join_mgrp: ERR
1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState = 0
failed from port 0x0002c90300044c61 (ibds2 HCA-1), sending
IB_SA_MAD_STATUS_REQ_INVALID
Sep 11 11:41:46 252731 [4EF83940] 0x01 -> __osm_mcmr_rcv_join_mgrp: ERR
1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState = 0
failed from port 0x0002c90300047b7d (ibds1 HCA-1), sending
IB_SA_MAD_STATUS_REQ_INVALID
Sep 11 11:41:46 252929 [43170940] 0x01 -> __osm_mcmr_rcv_join_mgrp: ERR
1B12: __validate_more_comp_fields, __validate_port_caps, or JoinState = 0
failed from port 0x0002c90300047b75 (ibas2 HCA-1), sending
IB_SA_MAD_STATUS_REQ_INVALID

What is the cause of these?

---
Regards
Barry Mavin
Recital Corporation
Chairman and CEO
Website: http://www.recital.com
MSN Messenger: Barry_Mavin-uAjRD0nVeow@public.gmane.org
Skype: BarryMavin
Direct line worldwide: +1 9785224139



> From: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Fri, 11 Sep 2009 11:16:44 +0530
> To: Barry Mavin <Barry.Mavin-sPOXD9PnZXtBDgjK7y7TUQ@public.gmane.org>
> Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OFED mailing list
> <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
> Subject: Re: [ofa-general] Re: [PATCH v2] infiniband-diags/scripts: Add
> 'ibcheckspeed' and 'ibcheckportspeed' to scripts
> 
>> # ibtracert 10.10.10.1 10.10.10.3
> 
> ibtracert only supports source/destination addresses to be specified
> in LID/GUID format. See man page of ibtracert.
> 
> -
> Keshetti Mahesh

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
