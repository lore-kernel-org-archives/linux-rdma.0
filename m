From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 7/9] rdma/cm: fix loopback address support
Date: Tue, 24 Nov 2009 21:09:32 +0200
Message-ID: <15ddcffd0911241109m3b93cfdek4e3bc4d73e28dffa@mail.gmail.com>
References: <OF34959131.79AC5DD5-ON88257677.00543B51-88257677.005450AC@us.ibm.com>
	 <4B0BA10B.8010207@voltaire.com> <4B0BAD77.8070806@mellanox.co.il>
	 <35A21E7711734ABAA1497D924BA7FA9A@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <35A21E7711734ABAA1497D924BA7FA9A-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>, "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> I will create a new librdmacm package that corresponds with the changes

I made all my testing of the patch set with librdmacm 1.0.10 and
patched 2.6.32-rc5 kernel, where as I wrote you, I was focusing on
AF_INET/PS_TCP and AF_INET/PS_IPOIB.
I understand that Dave was covering AF_INET6/PS_TCP with plenty of the
ipv6 variations.

So what will this new librdmacm package will let cover which wasn't
possible so far? do you refer to ipv6 support in mckey? anything else?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
