From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v2 rdma-next 00/29] Soft RoCE driver
Date: Thu, 16 Jun 2016 09:31:25 -0500
Message-ID: <00c101d1c7db$c3158df0$4940a9d0$@opengridcomputing.com>
References: <1466084751-29901-1-git-send-email-monis@mellanox.com> <20160616135056.GA27373@infradead.org> <CAG9sBKO7psY+YkLCeGH1s9jmEizdkySbPz0tbtbO45Mo4bvVSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG9sBKO7psY+YkLCeGH1s9jmEizdkySbPz0tbtbO45Mo4bvVSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Tal Alon' <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> >
> > I don't think adding a new driver not supporting FRs is acceptable in
> > 2016.  Even less so for a software protocol stack.
> 
> I hope very much to add this support in next series (v3) (and remove
> FMR at the same time). I just didn't want it to hold the submission of
> v2 so other parts of the code can be reviewed.

Great! :)

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
