From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/4] New RAW_PACKET QP type
Date: Tue, 8 Mar 2011 23:13:06 +0200
Message-ID: <AANLkTinG4q22MFBBVvkmJfNc5xFBJEurRDMX-6BDNXiY@mail.gmail.com>
References: <4CFC918D.1090708@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFC918D.1090708-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nir Muchtar <nirmu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Aleksey Senin <alekseys-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 6, 2010 at 9:32 AM, Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> The following patches add a new QP type named RAW_PACKET.
> This type of QP is used in Ethernet environment and intended for
> creation of a whole packet, including L2 headers, from userspace.


Hi Roland, any chance you can look on these raw qp patches for the
coming merge window? as you can see, there's some dependencies and
inter-relations between the mlx4 streeing changes to the raw qp
support, and having the raw qp support stay behind / out of tree makes
things complex to track. Also, what's more on the plate for the coming
window?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
