From: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 5/9] IB/core, rdmavt, hfi1: Send OPA cap_mask3
 in trap
Date: Wed, 31 May 2017 10:58:21 -0700
Message-ID: <20170531175821.GA29853@knc-06.sc.intel.com>
References: <20170526123257.8158.23943.stgit@scvm10.sc.intel.com>
 <20170526123536.8158.237.stgit@scvm10.sc.intel.com>
 <20170529161407.GB17751@mtr-leonro.local>
 <2fc7a7d6-9ba3-2365-45e3-946f56827dd9@intel.com>
 <20170531043235.GH5406@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170531043235.GH5406-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Henry, Michael N" <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 31, 2017 at 07:32:35AM +0300, Leon Romanovsky wrote:
>On Tue, May 30, 2017 at 11:32:22AM -0700, Henry, Michael N wrote:
>> On 5/29/2017 9:14 AM, Leon Romanovsky wrote:
>> > On Fri, May 26, 2017 at 05:35:37AM -0700, Dennis Dalessandro wrote:
>> > > From: Michael N. Henry <michael.n.henry-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > >
>> > > Provide the ability for IB clients to modify the OPA specific
>> > > capability mask and include this mask in the subsequent trap data.
>> > >
>> > > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
>> > > index 785e927..6c4f6da 100644
>> > > --- a/include/rdma/ib_verbs.h
>> > > +++ b/include/rdma/ib_verbs.h
>> > > @@ -576,7 +576,8 @@ struct ib_device_modify {
>> > >   enum ib_port_modify_flags {
>> > >   	IB_PORT_SHUTDOWN		= 1,
>> > >   	IB_PORT_INIT_TYPE		= (1<<2),
>> > > -	IB_PORT_RESET_QKEY_CNTR		= (1<<3)
>> > > +	IB_PORT_RESET_QKEY_CNTR		= (1<<3),
>> > > +	IB_PORT_OPA_MASK_CHG		= (1<<4)
>> > How will this flag be set?
>> >
>> This flag can be set as the port_modify_mask when calling ib_modify_port(..)
>
>My question is more general. I'm as a representative of these "IB
>clients" would like to know when and why should I use this flag.
>

Hi,
We have an OPA VNIC use case (patch coming up) to set/clear OPA capmask as 
below.

pm.set/clear_port_cap_mask = OPA_CAP_MASK3_IsEthOnFabricSupported;
ib_modify_port(hca, port, IB_PORT_OPA_MASK_CHG, &pm);

This patch support such usecase and we want to get comments early (if any) for 
that, hence this patch.

Niranjana

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
