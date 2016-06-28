From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 3/5] IB/isert: Limit the number of SG elements per work request
Date: Tue, 28 Jun 2016 14:13:35 -0500
Message-ID: <022501d1d171$2acf8dd0$806ea970$@opengridcomputing.com>
References: <419391ba-0c39-11ce-f249-84b428dc73d5@sandisk.com> <885f39a6-9d75-9999-d582-e403f072bec1@sandisk.com> <006d01d1d14a$0574f0b0$105ed210$@opengridcomputing.com> <6e513522-6b06-d942-bddd-cc00f9a32f44@sandisk.com> <01ca01d1d14f$0ae47160$20ad5420$@opengridcomputing.com> <9e8c6a52-3bf9-6b3f-1f36-d77205cb3ee0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9e8c6a52-3bf9-6b3f-1f36-d77205cb3ee0-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "'Nicholas A. Bellinger'" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, 'Parav Pandit' <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, 'Laurence Oberman' <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Hi Steve,
> 
> Can you use the code from the for-next branch in the following
> repository for your tests: https://github.com/bvanassche/linux.
> 

Which branch?

> I will post these patches tomorrow.
> 
> Thanks,
> 
> Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
