From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: iSER Connection via LIO not working
Date: Thu, 8 Jun 2017 16:28:23 +0000
Message-ID: <1496939302.3028.3.camel@wdc.com>
References: <2E68B5D1-49CF-4F2C-B7F3-DA20E05503B8@creamfinance.com>
         <CAANLjFraKgxAC09VH8u72SbQZs8WhXnnk87VQB0ywoVavC2hSg@mail.gmail.com>
         <2E0A092F-9530-44FB-8A6F-D76D8E94ABE0@creamfinance.com>
         <CAANLjFqg1ked1Ls0W=BRRw5o5vheHKnUw5C_5OVciFQd0H8djg@mail.gmail.com>
         <827EC8DD-86E7-4011-8F68-B29396B2034D@creamfinance.com>
         <CAANLjFqt_RqU6UFPCcZJ5Mec-ku__YErFb-VLrV4Qx9G7ArAZA@mail.gmail.com>
         <1790271E-1A6B-492D-B4B6-701873B23A01@creamfinance.com>
         <32E1700B9017364D9B60AED9960492BC3431F8F1@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC3431F8F1-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <83A337D7328A104B90EBAA19C3F7A673-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org" <thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org>, "mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-06-08 at 16:23 +0000, Marciniszyn, Mike wrote:
> This appears to be the only storage ULP that reads this field exported fr=
om drivers.

Hello Mike,

Are you sure of this? This is what grep tells me:

$ git grep -lw max_fast_reg_page_list_len | grep -Ev '^drivers/infiniband/h=
w/|^include/'
drivers/infiniband/core/rw.c
drivers/infiniband/sw/rxe/rxe.c
drivers/infiniband/ulp/iser/iser_verbs.c
drivers/infiniband/ulp/srp/ib_srp.c
drivers/nvme/host/rdma.c
net/sunrpc/xprtrdma/frwr_ops.c
net/sunrpc/xprtrdma/svc_rdma_transport.c

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
