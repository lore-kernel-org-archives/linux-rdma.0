From: "Chandramouli, Dasaratharaman"
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 10/11] IB/IPoIB: Modify ipoib_get_net_dev_by_params to
 lookup gid table
Date: Thu, 8 Dec 2016 15:11:04 -0800
Message-ID: <46992104-1235-6764-b440-1b986141cf86@intel.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1479843532-47496-11-git-send-email-dasaratharaman.chandramouli@intel.com>
 <20161122212057.GB6484@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161122212057.GB6484-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 11/22/2016 1:20 PM, Jason Gunthorpe wrote:
> On Tue, Nov 22, 2016 at 02:38:51PM -0500, Dasaratharaman Chandramouli wrote:
>> ipoib_get_net_dev_by_params compares incoming gid with local_gid
>> which is gid at index 0 of the gid table. OPA devices using larger
>> LIDs may have a different GID format than whats setup in the local_gid
>> field. Do a search of the gid table in those cases.
>
> Sorry, NAK, the incoming GID has to exactly match what is in IPoIB
> LLADDR, you can't do this or it breaks how the virtualization stuff is
> supposed to work with gid aliases.
>
> I'm skeptical about the other ipoib patch as well since ipoib should
> be dealing natively with 32 bit lids, I think you need to fix the path
> record stuff too instead of opening coding that in ipoib.

Thanks for the clarification. Will attempt to keep the incoming GID 
consistent with the GID assigned to the IPoIB interface.
Regarding your comments on path records, we are looking into supporting 
32 bit LIDs in the path record response.
Will post the revised patches.

>
> Jason
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
