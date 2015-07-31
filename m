From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] update ocrdma to dual license
Date: Fri, 31 Jul 2015 09:31:07 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1507310930240.12455@east.gentwo.org>
References: <1434127505-17739-1-git-send-email-devesh.sharma@avagotech.com> <20150630060631.GA21105@infradead.org> <CANjDDBh3pxLFe2o08KzAtw8dtVq94GK04x4YZ0nXA+YnVh5Bng@mail.gmail.com> <20150701072120.GB31381@infradead.org>
 <CANjDDBinTi43KTt14C7cJ0Uo=Do8Vt3G6bXutLbsViUFUG=jRg@mail.gmail.com> <2807E5FD2F6FDA4886F6618EAC48510E110A880D@CRSMSX101.amr.corp.intel.com> <20150703155234.GA6099@infradead.org> <CANjDDBh1C8Hh_MN9P1=N-g9tvwa-GF0h387_SHiE12cNVKfH2Q@mail.gmail.com>
 <20150708080108.GB5668@infradead.org> <559D7FA9.1040200@redhat.com> <20150708200212.GA28030@infradead.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150708200212.GA28030-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 8 Jul 2015, Christoph Hellwig wrote:

> So how about someone tells OFED to stop trying to enforce this BS?
>
> This just confirms my byass that Open-Fabrics Alliance are a bunch of
> idiots making life hard, similar to all their horrible OFED driver
> distributions that crated a total mess for everyone involved.

There are a number of commmits already that change the license. Lets
revert these:

commit b8f5595eb96c9fce1c907d13e89581e5061edf2e
Author: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Date:   Fri Jul 24 05:04:00 2015 +0530

    RDMA/ocrdma: update ocrdma module license string

    Change module_license from "GPL" to "Dual BSD/GPL"

    Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
    Cc: Duan Jiong <duanj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
    Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
    Cc: Jes Sorensen <Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Cc: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
    Cc: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Cc: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
    Cc: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
    Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Cc: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
    Cc: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Cc: Devendra Naga <devendra.aaru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
    Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

commit 71ee67306ecbdfc0c94ed93c77ff99d29e961d69
Author: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Date:   Fri Jul 24 05:03:59 2015 +0530

    RDMA/ocrdma: update ocrdma license to dual-license

    Change of license from GPLv2 to dual-license (GPLv2 and BSD 2-Clause)

    All contributors were contacted off-list and permission to make this
    change was received.  The complete list of contributors are Cc:ed here.

    Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
    Cc: Duan Jiong <duanj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
    Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
    Cc: Jes Sorensen <Jes.Sorensen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Cc: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
    Cc: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Cc: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
    Cc: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
    Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Cc: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
    Cc: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Cc: Devendra Naga <devendra.aaru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
    Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
