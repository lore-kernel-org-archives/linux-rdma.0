From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 00/26] New fast registration API
Date: Thu, 8 Oct 2015 11:21:58 +0300
Message-ID: <561627A6.1000409@dev.mellanox.co.il>
References: <1444290669-5252-1-git-send-email-sagig@mellanox.com>
 <20151008080103.GA29235@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151008080103.GA29235-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/8/2015 11:01 AM, Christoph Hellwig wrote:
> On Thu, Oct 08, 2015 at 10:50:43AM +0300, Sagi Grimberg wrote:
>> - Rebased against Doug's for-4.4 tree (4.3.0-rc1) + 4.3-rc fixes
>
> Does this means its not on top of the send_wr changes now?  I'm fine
> with that as I think your series is even more important than the send_wr
> split and I'm happy to rebase, but I'd also really like to see some
> progress on them..

Its on top of your wr_cleanup as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
