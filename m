From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [for-next 0/3] Add congestion control capability
Date: Wed, 23 Aug 2017 21:15:24 +0530
Message-ID: <CANjDDBhGoMRZr5vptGRoKZetjNawomXeuHM5XorCu0XG+RzYAg@mail.gmail.com>
References: <1503402587-24669-1-git-send-email-devesh.sharma@broadcom.com>
 <20170822123246.GX1724@mtr-leonro.local> <20170822151143.GB1201@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170822151143.GB1201-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon and Jason,

Sure we can definitely use this tool now or in the near-future for
controlling most of the device tuneable parameters etc. I am still
catching up on the older discussion related to this topic.

In the meanwhile I wanted to ask about the availability of this tool
in the upcoming standard OS distributions like SLES/RHEL etc. Do we
have any timeline for the availability, in which version should we
push/avail this tool?


-Regards
Devesh

On Tue, Aug 22, 2017 at 8:41 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Tue, Aug 22, 2017 at 03:32:46PM +0300, Leon Romanovsky wrote:
>> On Tue, Aug 22, 2017 at 07:49:44AM -0400, Devesh Sharma wrote:
>> > This patch series is to support congestion control capability
>> > on Broadcom NetXtreme-E 10/25/40/50 RDMA Ethernet Controllers.
>> >
>> > The implementation exposes congestion control related parameters
>> > to administrator using configfs.
>> >
>>
>> We have RDMAtool and netlink for configurations now, please use it.
>
> Yes, +1
>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
