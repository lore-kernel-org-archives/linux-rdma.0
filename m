From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2] IB/uverbs: Fix race between uverbs_close and remove_one
Date: Thu, 10 Mar 2016 21:27:34 +0530
Message-ID: <CANjDDBiM4SjaaQ8Z9rxVbRZoQ7MsYAo6tWx_AqHD-rsfmrCeeg@mail.gmail.com>
References: <1457343873-14869-1-git-send-email-devesh.sharma@broadcom.com>
 <20160307190833.GA1886@obsidianresearch.com> <CANjDDBiYagKm79n5sWNsCnxruSzqDqZYREmw1mGBR_upapF4hQ@mail.gmail.com>
 <20160308175334.GB10805@obsidianresearch.com> <56E053C8.8050008@dev.mellanox.co.il>
 <20160309190354.GD21139@obsidianresearch.com> <CANjDDBj=F-LTSDMesD97CvvJQWOW6fecuDLY2a9sBZ220jMYMg@mail.gmail.com>
 <CANjDDBhnJgic4QP-mL7_7cTAh-CH7xaTO147MNqat=aZ45B1nw@mail.gmail.com> <56E19676.4070805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E19676.4070805-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 10, 2016 at 9:14 PM, Yishai Hadas
<yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 3/10/2016 5:25 PM, Devesh Sharma wrote:
>>
>> Hi Jason.
>> I tested this approach and again hit the same panic. Thus, looks like
>> there is no escape other than using
>> srcu and complete().
>
>
> As expected, see my analysis in my answer to Jason, his suggestion didn't
> fix the race, need to go with the sruc solution.

Yes, I also had doubts so thought of confirming before proceeding. I
will post V3

>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
