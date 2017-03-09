From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: libacm fails to build
Date: Thu, 9 Mar 2017 23:47:46 +0000
Message-ID: <1489103252.2597.20.camel@sandisk.com>
References: <20170309102527.3ni4pkuendwzqzrm@paradies.suse.de>
         <20170309171014.GC12694@obsidianresearch.com>
         <1489098918.2597.12.camel@sandisk.com>
         <20170309224904.GA5867@obsidianresearch.com>
         <1489099998.2597.16.camel@sandisk.com>
         <20170309230453.GA7844@obsidianresearch.com>
         <1489101151.2597.18.camel@sandisk.com>
         <20170309232352.GA12387@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170309232352.GA12387-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <AC9F7B01E0975D4F9DC61578001A7270-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "pth-l3A5Bk7waGM@public.gmane.org" <pth-l3A5Bk7waGM@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-03-09 at 16:23 -0700, Jason Gunthorpe wrote:
> It seems like something else is going on with your system, I wonder if
> your system could have a conflicting rpm macro?

That might be what's causing trouble ... both /etc/rpm/macros.kde4 and
/etc/rpm/macros.qt5 contain the following definition:

%make_jobs %{__make} %{?_smp_mflags} VERBOSE=3D1

How about explicitly defining %make_jobs in the rdma-core spec to work
around this?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
