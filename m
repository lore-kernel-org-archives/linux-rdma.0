From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 9/9] ib_verbs: Add a new qp create flag to request
 features for Ethernet over IB
Date: Fri, 2 Sep 2016 10:14:39 -0700
Message-ID: <9286afcb-dd7a-b2b9-fa33-966952e91349@oracle.com>
References: <1472774969-18997-1-git-send-email-knut.omang@oracle.com>
 <1472774969-18997-10-git-send-email-knut.omang@oracle.com>
 <20160902021729.GE30057@obsidianresearch.com>
 <1472792670.9410.276.camel@oracle.com> <1472814057.3975.47.camel@oracle.com>
 <b38c5cf6-4e07-33eb-8704-284498481bb6@oracle.com>
 <20160902171107.GF24997@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160902171107.GF24997-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/2/2016 10:11 AM, Jason Gunthorpe wrote:
> On Fri, Sep 02, 2016 at 09:19:43AM -0700, Santosh Shilimkar wrote:
>
>> Don't want to hijack your patch but I also have seen another need where
>> ULP needs to pass additional information to driver for creating
>> RC qp with couple of add-ons . My current thought is to use reserved
>> QP flag bits (bits 26-31, for low level drivers' internal use)
>
> Nope, absolutely not.
>
> Propose an actual verbs API extensions for what you want to do just
> like Mellanox has been doing.
>
Thanks Jason for comments. Will do !!

Regards,
Santosh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
