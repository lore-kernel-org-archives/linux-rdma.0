From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: qedr and vmw_pvrdma are not packaged in rdma-core
Date: Thu, 2 Feb 2017 10:49:35 -0700
Message-ID: <20170202174935.GA17977@obsidianresearch.com>
References: <20170202062628.GZ6005@mtr-leonro.local>
 <20170202163831.GA10782@obsidianresearch.com>
 <20170202174415.GC6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170202174415.GC6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ram Amrani <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 02, 2017 at 07:44:15PM +0200, Leon Romanovsky wrote:
> On Thu, Feb 02, 2017 at 09:38:31AM -0700, Jason Gunthorpe wrote:
> > On Thu, Feb 02, 2017 at 08:26:28AM +0200, Leon Romanovsky wrote:
> > > Hi Ram and Adit,
> > >
> > > I want to bring to your attention that qedr and vmw_pvrdma drivers are
> > > missing from various package files available in rdma-core.
> >
> > It is handled automatically, can't be missing:
> >
> > $ buildlib/cbuild pkg jessie
> > $ dpkg-deb -c ../ibverbs-providers_13-1_amd64.deb
> > -rw-r--r-- root/root     35024 2017-02-02 09:31 ./usr/lib/x86_64-linux-gnu/libibverbs/libqedr-rdmav2.so
> > -rw-r--r-- root/root     18600 2017-02-02 09:31 ./usr/lib/x86_64-linux-gnu/libibverbs/libvmw_pvrdma-rdmav2.so
> >
> > $ buildlib/cbuild pkg fc25
> > $ rpm -q -l -p ../libibverbs-13-1.fc25.x86_64.rpm
> > /usr/lib64/libibverbs/libqedr-rdmav2.so
> > /usr/lib64/libibverbs/libvmw_pvrdma-rdmav2.so
> >
> > > RedHat has different scheme with explicit declaration, from redhat/rdma-core.spec
> > > 98 Provides: librxe = %{version}-%{release}
> > > 99 Obsoletes: librxe < %{version}-%{release}
> >
> > This is only for things that were previously packaged in redhat, qedr
> > and vmw_pvrdma have not been, so they should not include those
> > stanzas. It is similar to the obsoletes/replaces in debian/control.
> 
> Are you sure? I can't find librxe here.
> https://www.rpmfind.net/linux/rpm2html/search.php?query=librxe&submit=Search+...&system=&arch=

Yes, I am sure.

Someone got overzealous then, the provides should be removed.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
