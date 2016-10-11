From: "Chandramouli, Dasaratharaman"
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 03/11] IB/sa: Modify SM Address handle to program GRH
 when using large lids
Date: Tue, 11 Oct 2016 12:19:21 -0700
Message-ID: <7aede75b-ae59-8e9c-96c3-b5080d9707e5@intel.com>
References: <1474652674-13110-1-git-send-email-ira.weiny@intel.com>
 <1474652674-13110-4-git-send-email-ira.weiny@intel.com>
 <20160923183217.GD13920@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160923183217.GD13920-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The reason for doing this in the kernel was that we wanted a more 
uniform approach in specifying extended LIDs across the user and the 
kernel space. This also meant we could leave the ah_attr.dlid field in 
the kernel to be 16 bits.

We will extend ah_attr.dlid to 32 bits in the kernel per your 
suggestion. This should make specifying extended LID information in the 
GRH of the address handle unnecessary.

Thanks,
Dasa


On 9/23/2016 11:32 AM, Jason Gunthorpe wrote:
> On Fri, Sep 23, 2016 at 01:44:26PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>> From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> When either the port lid or the sm lid is above the ib unicast lid
>> space, the SMI creates an address handle with the revelant GRH
>> information.
>
> Woah, I though you were only using that horrible GID hack for the
> uABI.
>
> Don't do such crazy things in the kernel. Fix the internal kernel to
> support your larger lid.
>
> Jason
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
