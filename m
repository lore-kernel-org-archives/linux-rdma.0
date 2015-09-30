From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC] IB/mad: remove obsolete snoop interface
Date: Wed, 30 Sep 2015 15:03:00 -0400
Message-ID: <560C31E4.2080007@dev.mellanox.co.il>
References: <1443592864-32019-1-git-send-email-ira.weiny@intel.com> <560BDB97.8010908@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E1CBA2FA4@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E1CBA2FA4-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/30/2015 12:32 PM, Weiny, Ira wrote:
>>
>> On 9/30/2015 2:01 AM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>>> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>
>>> This interface has no current users and is obsolete.
>>
>> There are no in tree users of this but there is Sean's madeye tool (which is out
>> of tree). This is still a useful debug tool for MADs.
> 
> Where is that?  

It's been out of tree for some time now. For one place, it can be found
on OpenFabrics site in some old and moldy OFED.

> I did not think it was supported any longer?

It still works AFAIK.

> I have a series of about 5 patches which implement tracing in the MAD stack which I was working through and was going to submit 

Does your MAD stack tracing include the dumping and decode of sent and
received MADs ?

-- Hal

> along with this patch (those are still being tested in my spare time).  I just wanted put this out here because of the patch Nicholas posted yesterday.
>>
>>> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>> ---
>>>
>>> This has undergone a medium level of testing.  I have run it against
>>> mlx4, qib, and OPA hardware and it does not seem to cause any regressions.
>>>
>>>  drivers/infiniband/core/mad.c      | 226 +------------------------------------
>>>  drivers/infiniband/core/mad_priv.h |  13 ---
>>>  2 files changed, 5 insertions(+), 234 deletions(-)
>>
>> There are also snoop changes needed in include/rdma/ib_mad.h.
> 
> I'll look into it if there are no other objections to removing the snoop interface.
>
>>
>> Is it correct to assume that OPA_CAP_MASK3_IsSnoopSupported in
>> opa_port_info.h is not related to this ?
> 
> Nope, not related.
> 
> Ira
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
