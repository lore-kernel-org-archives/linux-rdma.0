From: "Moni Shoua" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] naming for new QP types
Date: Sun, 4 Jul 2010 11:26:08 +0300
Message-ID: <7E95F01E94AB484F83061FCFA35B39F86D8A12@exil.voltaire.com>
References: <4C2CB5EC.1080501@Voltaire.COM><CF9C39F99A89134C9CF9C4CCB68B8DDF25A1002191@orsmsx501.amr.corp.intel.com><7E95F01E94AB484F83061FCFA35B39F86D8875@exil.voltaire.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25A1002332@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A1002332-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Aleksey Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If I understand you right this time then you ask what about will happen
if user calls create_qp() from user space with qp_type=6. Right?

I guess that this should be handled in code like with any other illegal
value.

---------------------------------------
  Moni Shoua|  +972-54-5567934  


-----Original Message-----
From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Friday, July 02, 2010 6:37 PM
To: Moni Shoua; Roland Dreier
Cc: linux-rdma; Or Gerlitz; Walukiewicz, Miroslaw; Aleksey Senin
Subject: RE: [RFC] naming for new QP types

> Along with the patches to the kernel we will send a patch to 
> libibverbs to expose the new values

I was actually asking if a user space app could access the existing
definitions/values in any way.  For example, if a user space app called
create qp with a hard-coded value of 6, what would happen?

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
