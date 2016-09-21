From: Dong Young Yoon <dyoon-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Subject: Unreliable Connection (IBV_QPT_UC) and rdma_accept()
Date: Wed, 21 Sep 2016 19:07:14 -0400
Message-ID: <13A5FB85-6677-4641-85F1-0670F62F17E4@umich.edu>
Mime-Version: 1.0 (Mac OS X Mail 10.0 \(3226\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

I have been trying to implement simple client/server system that uses UC =
instead of RC in order to test the performance of RDMA Writes under UC =
against RDMA Reads under RC. When I switch from RC to UC, rdma_accept() =
at the server fails with =E2=80=9CInvalid Argument (EINVAL)=E2=80=9D. I =
have tried various values for queue pair attributes and also tried =
RDMA_PS_IB, RDMA_PS_UDP for rdma_create_id(), but nothing has worked for =
me. The problem seems to be very similar to what had been discussed in =
this thread last year: =
http://www.spinics.net/lists/linux-rdma/msg23071.html, yet I could not =
find the solution to the problem in the thread.
Has there been any development regarding UC since then? I am more than =
happy to provide more information that would help in resolving this =
issue.

Thanks,
Dong Young
--
Dong Young Yoon
PhD Candidate in Computer Science
University of Michigan
2260 Hayward St.
Ann Arbor, MI 48109-2121
Office: 4957 Beyster
Phone: 734-780-9175
Email: dyoon-63aXycvo3TyHXe+LvDLADg@public.gmane.org=20

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
