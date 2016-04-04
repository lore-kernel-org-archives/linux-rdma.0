From: sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: iSER initiator in 4.5 is unhappy..
Date: Mon, 4 Apr 2016 20:38:52 +0300
Message-ID: <5702A6AC.9020008@grimberg.me>
References: <20160404134656.GA30269@infradead.org>
 <5702A46F.5070109@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5702A46F.5070109-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Odd, I see that Ming's patches made it to 4.5...

Can you verify that this patches exist in your tree:
e827091cb1bc block: merge: get the 1st and last bvec via helpers
25e71a99f10e block: get the 1st and last bvec via helpers
e0af29171aa8 block: check virt boundary in bio_will_gap()
7bcd79ac50d9 block: bio: introduce helpers to get the 1st and last bvec
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
