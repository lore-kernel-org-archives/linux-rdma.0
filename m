From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 1/2] IB/qib: Remove unused variable (char
 *qib_sdma_event_names[])
Date: Wed, 28 Feb 2018 14:16:08 -0700
Message-ID: <20180228211608.GF13394@ziepe.ca>
References: <1519769143-20000-1-git-send-email-hernan@vanguardiasur.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1519769143-20000-1-git-send-email-hernan@vanguardiasur.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?Q?Hern=C3=A1n?= Gonzalez <hernan@vanguardiasur.com.ar>
Cc: dennis.dalessandro@intel.com, mike.marciniszyn@intel.com, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 27, 2018 at 07:05:42PM -0300, Hernán Gonzalez wrote:
> Note: This is compile only tested as I have no access to the hw.
> 
> This variable was not used anywhere in the code. Removing it saves 88 bytes.
> 
> add/remove: 0/1 grow/shrink: 0/0 up/down: 0/-88 (-88)
> Function                                     old     new   delta
> qib_sdma_event_names                          88       -     -88
> Total: Before=2874565, After=2874477, chg -0.00%
> 
> Signed-off-by: Hernán Gonzalez <hernan@vanguardiasur.com.ar>
>  drivers/infiniband/hw/qib/qib.h      |  1 -
>  drivers/infiniband/hw/qib/qib_sdma.c | 14 --------------
>  2 files changed, 15 deletions(-)

Applied the series to for-next, thanks

Jason
