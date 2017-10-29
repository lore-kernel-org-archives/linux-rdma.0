From: Moni Shoua <monis@mellanox.com>
Subject: Re: [PATCH 2/2] IB/rxe: don't crash, if allocation of crc algorithm failed
Date: Sun, 29 Oct 2017 10:20:18 +0300
Message-ID: <CAG9sBKPvK95UpxS_4SO0WxJuCyYrjAhe=Am-Ev2Kp+mQFxyYhA@mail.gmail.com>
References: <20171027155923.36156-1-tbogendoerfer@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027155923.36156-1-tbogendoerfer@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 27, 2017 at 6:59 PM, Thomas Bogendoerfer
<tbogendoerfer@suse.de> wrote:
> Following crash happens, if crc algorithm couldn't be allocated:
>
> [ 1087.989072] rdma_rxe: loaded
> [ 1097.855397] PCLMULQDQ-NI instructions are not detected.
> [ 1097.901220] rdma_rxe: failed to allocate crc algorithmi err:-2
> [ 1097.901248] BUG: unable to handle kernel
> [ 1097.901249] NULL pointer dereference
> [ 1097.901250]  at 0000000000000046
> [...]
>
> Reason is that rxe->tfm is assigned the error return, which will then
> be used for crypto_free_shash() in rxe_cleanup. Fix by using a
> temporay variable and assigning it rxe->tfm after allocation succeeded.
>
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Fix looks good only a Fixes line is missing from the commit message. Please add.
