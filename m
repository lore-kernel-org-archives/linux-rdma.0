From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: 4.4's rdma plate
Date: Wed, 14 Oct 2015 16:59:45 +0300
Message-ID: <561E5FD1.6080902@mellanox.com>
References: <CAJ3xEMhniP7x3NCM51nCccB7wBiQfWiyqaeVm8cdx=SuotrHYQ@mail.gmail.com>
 <CAJ3xEMiF1xrwBb4B54HEJVWAds76i9oPkKx-ROf3tubeH6a8TA@mail.gmail.com>
 <561E510C.8060501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <561E510C.8060501-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/14/2015 3:56 PM, Doug Ledford wrote:
> Yes Or, I'm working on it.  A new 4.3-rc pull request should come out
> today and an update on the for next area probably as well.

Excellent. Re the next area, as was communicated to you multiple times, 
we really need the next bits to be in
your kernel.org tree and on one branch, else we can't really rebase 
re-spins of current/new patch series, pull
these bits into our internal build and regression systems. Also w.o 
this, you are highly exposed to
miss possible conflicts that could have caught by your branch being 
registered to linux-next and again get
those shouts from Linus when he steps on the conflicts while pulling, we 
had enough of it, really.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
