From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: libacm fails to build
Date: Thu, 9 Mar 2017 16:04:53 -0700
Message-ID: <20170309230453.GA7844@obsidianresearch.com>
References: <20170309102527.3ni4pkuendwzqzrm@paradies.suse.de>
 <20170309171014.GC12694@obsidianresearch.com>
 <1489098918.2597.12.camel@sandisk.com>
 <20170309224904.GA5867@obsidianresearch.com>
 <1489099998.2597.16.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489099998.2597.16.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "pth-l3A5Bk7waGM@public.gmane.org" <pth-l3A5Bk7waGM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 09, 2017 at 10:53:31PM +0000, Bart Van Assche wrote:
> Sorry, I used the wrong base for the diff command. How about the patch below
> to fix the SuSE build:

Are you using an older suse? I just updated my tumbleweed image and it
built fine with HEAD.

What is in your /etc/rpm/macros.cmake? All the suse's I looked at have
this in that file:

 %cmake_install \
    DESTDIR=%{buildroot} %__builder install -C %__builddir

It comes from here (tumbleweed):

builder-40f0d1607cec:/etc/rpm # rpm -qf /etc/rpm/macros.cmake
cmake-3.7.2-1.1.x86_64

(13.2):

bash-4.2# rpm -qf /etc/rpm/macros.cmake
cmake-3.0.2-6.1.x86_64

?

I also checked and it built OK on OpenSuse 13.2

So.. I'm confused what we are trying to fix here? :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
