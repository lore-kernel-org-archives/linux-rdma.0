From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 3/5] IB/isert: Limit the number of SG elements per work request
Date: Tue, 28 Jun 2016 09:28:23 -0500
Message-ID: <006b01d1d149$53d41200$fb7c3600$@opengridcomputing.com>
References: <419391ba-0c39-11ce-f249-84b428dc73d5@sandisk.com> <885f39a6-9d75-9999-d582-e403f072bec1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <885f39a6-9d75-9999-d582-e403f072bec1-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "'Nicholas A. Bellinger'" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, 'Parav Pandit' <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Laurence Oberman' <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> 
> Limit the number of SG elements per work request to what the queue
> pair supports.
> 
> Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")

I think the above is the wrong commit.  Maybe this one?

commit 38a2d0d429f1d87315c55d9139b8bdf66d51c4f4
Author: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Date:   Tue May 3 18:01:13 2016 +0200

    IB/isert: convert to the generic RDMA READ/WRITE API



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
