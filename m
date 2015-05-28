From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/14] IB/mad: Add support for OPA MAD processing.
Date: Thu, 28 May 2015 10:07:23 +0300
Message-ID: <5566BEAB.5050405@mellanox.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432109615-19564-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/20/2015 11:13 AM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> Ira Weiny (14):
>    IB/mad: Clean up ib_find_send_mad
>    IB/mad: Create an RMPP Base header
>    IB/mad: Create handle_ib_smi
>    IB/mad: Add helper function for smi_handle_dr_smp_send
>    IB/mad: Add helper function for smi_handle_dr_smp_recv
>    IB/mad: Add helper function for smi_check_forward_dr_smp
>    IB/mad: Add base version to ib_create_send_mad
Ira,

Again... you should do better w.r.t patch titles --

"Add helper function name_of_function_x"

isn't the way to go, try

"Add helper function for functionality X"

no for "Add base version to function_x"

yes for "Add base version when doing X"

no for "Create function_x"
yes for "Add functionality X"

etc

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
