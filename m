From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] net/mlx5: Add DCT command interface
Date: Tue, 26 Dec 2017 15:47:08 +0200
Message-ID: <CAG9sBKOT3bGrpLb+cfzYuXofoAE_sDHLewy=fkFmnCVea_k2-w@mail.gmail.com>
References: <20171226091634.2352-1-leon@kernel.org> <20171226091634.2352-2-leon@kernel.org>
 <CAJ3xEMhwLaBVU9re99cOe8cgRDcGPfJ=SWf4zYH6v8s_rrKNEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhwLaBVU9re99cOe8cgRDcGPfJ=SWf4zYH6v8s_rrKNEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> put the  create/destroy_qprqsq_common thing into a pre patch

I don't think that just changing a name for a function justifies a
separate patch especially if the reason is the use of it in the rest
of the patch
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
