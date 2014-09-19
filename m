From: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: RFC: FMR support in SRP
Date: Fri, 19 Sep 2014 15:11:45 +0200
Message-ID: <CAMGffEkN4OmJVi6UV7PtRYq5q3XZfJVTEaJFqvypx0W8Aq8cRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart and all,

During go through SRP FMR support, I found ib_srp pre-alloc
fmr_list/map_page in each request,
fmr_list are alloced as many as target->cmd_sg_cnt

I add some debug message when run fio test with different settings.
Result show, state.ndesc and state.nmdesc is 1, state.npages is 0,
after srp_map_sg,
my question is : do we really need as many cmd_sg_cnt fmr_list, or I
miss something,  ndesc and nmdesc could be bigger than 1?



--=20

Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang

Linux Kernel Developer Storage
ProfitBricks GmbH  The IaaS-Company.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
