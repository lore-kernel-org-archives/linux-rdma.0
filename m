From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: crash in 4.14-rc1 with IPoIB
Date: Wed, 20 Sep 2017 10:32:37 -0600
Message-ID: <20170920163237.GD536@obsidianresearch.com>
References: <20170920095339.zhfymeyfbhiyepz5@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170920095339.zhfymeyfbhiyepz5-qw2SdCWA0PpjqqEj2zc+bA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 20, 2017 at 11:53:39AM +0200, Johannes Thumshirn wrote:
> I wanted to try out Christoph's NVMe multipathing patchset on my NVMe OmniPath
> setup and merged it into 4.14-rc1. On bootup I stumbled upon that splat and no
> RDMA operation was possible:

I think this was already found and fixed a month ago?? The oops is the same:

https://patchwork.kernel.org/patch/9932505/

Doug, one of the topics during the LPC was 'what to QA' - it
obviously causes QA problems if known bugs are left to sit on the
mailing list for a month :(

These are excatly the things need to get to Linus faster to get
people on board the QA upstream train..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
