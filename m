From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH RFC 0/3] Introduce device attribute rdma_read_access_flags
Date: Tue, 10 Nov 2015 10:18:29 -0600
Message-ID: <564218D5.1060900@opengridcomputing.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <20151110113141.GA23093@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151110113141.GA23093-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/10/2015 5:31 AM, Christoph Hellwig wrote:
> On Tue, Nov 10, 2015 at 12:44:12PM +0200, Sagi Grimberg wrote:
>> Instead of each ULP being aware of iWARP/IB protocol in order
>> to determine the rdma_read access flags, have it accessible
>> as an attribute in the ib_device.
>>
>> Patch 2,3 fixes RDS and svcrdma which gave remote access to rdma_reads
>> unconditionally.
>>
>> This patchset goes on top of Christoph's device attributes merge into
>> struct ib_device.
> FYI, I've updated the git branch to be based on current linus' tree
> which required a few bit to be fixed.  I'd also like to note that while
> everyone but Or seemed to be generally fine with it I'd really prefer
> and actualy revivewed-by or acked-by tag.
> --

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
