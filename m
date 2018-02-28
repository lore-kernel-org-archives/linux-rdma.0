From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/rxe: Remove unused variable (char
 *rxe_qp_state_name[])
Date: Wed, 28 Feb 2018 14:16:28 -0700
Message-ID: <20180228211628.GG13394@ziepe.ca>
References: <1519769278-20094-1-git-send-email-hernan@vanguardiasur.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1519769278-20094-1-git-send-email-hernan@vanguardiasur.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?Q?Hern=C3=A1n?= Gonzalez <hernan@vanguardiasur.com.ar>
Cc: monis@mellanox.com, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 27, 2018 at 07:07:58PM -0300, Hernán Gonzalez wrote:
> Note: This is compile only tested as I have no access to the hw.
> This variable was not used anywhere in the code. Removing it saves 24 bytes.
> 
> add/remove: 0/1 grow/shrink: 0/0 up/down: 0/-24 (-24)
> Function                                     old     new   delta
> rxe_qp_state_name                             24       -     -24
> Total: Before=3348732, After=3348708, chg -0.00%
> 
> Signed-off-by: Hernán Gonzalez <hernan@vanguardiasur.com.ar>
>  drivers/infiniband/sw/rxe/rxe_qp.c    | 9 ---------
>  drivers/infiniband/sw/rxe/rxe_verbs.h | 2 --
>  2 files changed, 11 deletions(-)

Applied to for-next, thanks

Jason
