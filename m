From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: RDMA/CM and multiple QPs
Date: Thu, 10 Sep 2015 12:50:33 +0300
Message-ID: <55F15269.2060200@dev.mellanox.co.il>
References: <20150906064550.GA30683@infradead.org>
 <55EED54B.7090608@dev.mellanox.co.il> <20150908131407.GB5316@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150908131407.GB5316-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> What I'm more interested in is a way to tell the CM that I only
> want routes that are using this ib_device that I got from the first
> lookup as all others are useless for me.
>

I'm not sure I understand what you are aiming for? if you connect to
a single address multiple times you will get the same device because
it is the same route right?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
