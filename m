From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 01/24] IB/core: Introduce new fast registration API
Date: Tue, 29 Sep 2015 09:49:24 +0300
Message-ID: <560A3474.3040603@dev.mellanox.co.il>
References: <1442482947-27785-1-git-send-email-sagig@mellanox.com>
 <1442482947-27785-2-git-send-email-sagig@mellanox.com>
 <5601C65F.8060403@sandisk.com> <5603A841.70509@dev.mellanox.co.il>
 <5609A9D0.8030607@sandisk.com> <20150929055907.GA29758@infradead.org>
 <560A341F.7030108@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <560A341F.7030108-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/29/2015 9:47 AM, Sagi Grimberg wrote:
>> Shouldn't higher layers take care of this?  Trying to implement the same
>> coalescing algorithm at various layers isn't very optimal, although we
>> need to decide and document which one is responsible.
>
> The block layer can take care of it, but I'm not sure about NFS/RDS at
> the moment (IIRC Steve specifically asked if this API would take care
> of chunking contig sg elements) so I'd rather keep it in until we are
> absolutely sure we don't need it.
>
> I can add a documentation statement for it.

Actually its documented:

  * Constraints:
  * - The first sg element is allowed to have an offset.
  * - Each sg element must be aligned to page_size (or physically
  *   contiguous to the previous element). In case an sg element has a
  *   non contiguous offset, the mapping prefix will not include it.
  * - The last sg element is allowed to have length less than page_size.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
