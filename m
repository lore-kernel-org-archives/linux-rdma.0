From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 00/14] index e382a3ca759e..d4a471a76d82 100644
Date: Fri, 5 Jan 2018 22:44:06 +0200
Message-ID: <CAJ3xEMjGwGbikOnhv9wtsKe_Cq42R_aF8p=LiWuxhppzKcXvbQ@mail.gmail.com>
References: <20180104152544.28919-1-leon@kernel.org> <CAJ3xEMjptQf99ZdGxkB6kTh9LkQ7-pjiObMh+knDWXFStPOg7Q@mail.gmail.com>
 <2618f285-6fa4-06ac-4b4a-51d0b2660b61@mellanox.com> <CAJ3xEMhVxBqJUwdRn3BXJPnf9J-_gXtrWrQgun3bCEW7W7Oq1w@mail.gmail.com>
 <792bac90-b1eb-110f-399c-08d5309d92dd@mellanox.com> <CAJ3xEMjOGEQQf+y4wEEPiS_F9fhYmDwBmd=ucUDQX_9416gzKQ@mail.gmail.com>
 <d15d980b-1d67-277e-60f8-0b7e92035a06@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d15d980b-1d67-277e-60f8-0b7e92035a06-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 5, 2018 at 5:57 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote=
:
> Unmodified driver on one side fo the multihost or even a non-multihost co=
nfiguration with unmodified drivers with a card with this feature enabled w=
ould be the same as the VM scenario.  Single one port IB device per functio=
n, with the unbalanced allocation of schedule queues in FW.

got it. I guess if we want we can try and improve later things on the FW
side using the proposed driver/FW API, since the FW does know if a driver
instance is unaware (they use host id of 0s).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
