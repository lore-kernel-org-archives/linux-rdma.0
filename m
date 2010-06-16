From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 5/5] dapl-2.0 - scm, ucm: add pkey, pkey_index, sl
 override for QP's
Date: Wed, 16 Jun 2010 11:56:00 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9830103BF25EB@orsmsx506.amr.corp.intel.com>
References: <E3280858FA94444CA49D2BA02341C9830103BF2437@orsmsx506.amr.corp.intel.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF259E4E04A4@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF259E4E04A4-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>-----Original Message-----
>From: Hefty, Sean 
>Sent: Wednesday, June 16, 2010 10:27 AM
>To: Davis, Arlin R; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; ofw_list
>Subject: RE: [PATCH 5/5] dapl-2.0 - scm, ucm: add pkey, 
>pkey_index, sl override for QP's
>
>> On a per open basis, add environment variables
>> DAPL_IB_SL, DAPL_IB_PKEY, DAPL_IB_PKEY_INDEX
>
>Why do you need both the pkey and index?  Either by itself is 
>sufficient, but the pkey itself is a better choice IMO.

You don't need both, it's just a matter of convenience 
for consumers.  
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
