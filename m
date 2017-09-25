From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: Question on mlx5-ib auto load
Date: Mon, 25 Sep 2017 13:40:58 +0200
Message-ID: <1506339658.3615.12.camel@profitbricks.com>
References: <daab19a4-98c8-3115-065d-2c40c5843121@grimberg.me>
         <20170924185559.GI25094@mtr-leonro.local>
         <23e29fc3-408b-1809-97eb-a105ab0e6488@grimberg.me>
         <20170924195730.GC18007@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170924195730.GC18007-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Sonntag, den 24.09.2017, 13:57 -0600 schrieb Jason Gunthorpe:
> On Sun, Sep 24, 2017 at 10:49:25PM +0300, Sagi Grimberg wrote:
> 
> > # cat /etc/os-release
> > NAME="Ubuntu"
> > VERSION="16.04 LTS (Xenial Xerus)"
> 
> This has the initrd problem I mentioned.

which is following bug:
https://bugs.debian.org/871595
https://launchpad.net/bugs/1719302

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web: https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Achim Weiss.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
