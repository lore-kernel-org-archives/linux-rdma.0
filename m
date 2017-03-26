From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sun, 26 Mar 2017 10:45:36 -0400
Message-ID: <1490539536.2404.82.camel@redhat.com>
References: <1490466578.2404.55.camel@redhat.com>
         <CA+55aFx+p+grY-vLzHOmj4VFKvni3eHUmO_hn+AzmHXw2MeUZg@mail.gmail.com>
         <1490536239.2404.80.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490536239.2404.80.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-03-26 at 09:50 -0400, Doug Ledford wrote:
> rdma-dev-19.lab.bos.redhat.com - ConnectX-4 IB/RoCE (using LACP LAG)
> dledford	HTTP	2017-03-22 10:34:28 -04:00	Distro
> Tree	Provision		Fedora-Rawhide-20170321.n.0
> Everything x86_64
> 
> rdma-dev-20.lab.bos.redhat.com - ConnectX-4 IB/RoCE (using LACP LAG)
> dledford	HTTP	2017-03-22 10:34:45 -04:00	Distro
> Tree	Provision		Fedora-Rawhide-20170321.n.0
> Everything x86_64

FWIW, it normally wouldn't take me that long to do my testing, but this
was the first time that I had configured these machines to use dual
port LACP LAG and then run RoCE over the top of the bonded interface.
 There was a lot of time spent getting the settings in the switches and
the configuration files for NetworkManager all tweaked properly.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
