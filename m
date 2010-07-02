From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] naming for new QP types
Date: Fri, 2 Jul 2010 08:36:47 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A1002332@orsmsx501.amr.corp.intel.com>
References: <4C2CB5EC.1080501@Voltaire.COM>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25A1002191@orsmsx501.amr.corp.intel.com>
 <7E95F01E94AB484F83061FCFA35B39F86D8875@exil.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7E95F01E94AB484F83061FCFA35B39F86D8875-QfUkFaTmzUSUvQqKE/ONIwC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Along with the patches to the kernel we will send a patch to libibverbs
> to expose the new values

I was actually asking if a user space app could access the existing definitions/values in any way.  For example, if a user space app called create qp with a hard-coded value of 6, what would happen?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
