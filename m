From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/uverbs: Add missing braces in anonymous union
 initializers
Date: Tue, 17 Apr 2018 20:17:41 -0600
Message-ID: <20180418021741.GA24191@ziepe.ca>
References: <1523285567-26270-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1523285567-26270-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Doug Ledford <dledford@redhat.com>, Matan Barak <matanb@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 09, 2018 at 04:52:47PM +0200, Geert Uytterhoeven wrote:
> With gcc-4.1.2:
> 
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:366: error: unknown field ‘ptr’ specified in initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:367: error: unknown field ‘type’ specified in initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:367: warning: missing braces around initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:367: warning: (near initialization for ‘uverbs_flow_action_esp_keymat[0].<anonymous>.<anonymous>’)
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:368: error: unknown field ‘min_len’ specified in initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:368: warning: excess elements in union initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:368: warning: (near initialization for ‘uverbs_flow_action_esp_keymat[0].<anonymous>’)
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:368: error: unknown field ‘len’ specified in initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:368: warning: excess elements in union initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:368: warning: (near initialization for ‘uverbs_flow_action_esp_keymat[0].<anonymous>’)
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:369: error: unknown field ‘flags’ specified in initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:369: warning: excess elements in union initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:369: warning: (near initialization for ‘uverbs_flow_action_esp_keymat[0].<anonymous>’)
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:376: error: unknown field ‘ptr’ specified in initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:377: error: unknown field ‘type’ specified in initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:377: warning: missing braces around initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:377: warning: (near initialization for ‘uverbs_flow_action_esp_replay[0].<anonymous>.<anonymous>’)
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:379: error: unknown field ‘len’ specified in initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:379: warning: excess elements in union initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:379: warning: (near initialization for ‘uverbs_flow_action_esp_replay[0].<anonymous>’)
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:383: error: unknown field ‘ptr’ specified in initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:384: error: unknown field ‘type’ specified in initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:385: error: unknown field ‘min_len’ specified in initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:385: warning: excess elements in union initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:385: warning: (near initialization for ‘uverbs_flow_action_esp_replay[1].<anonymous>’)
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:385: error: unknown field ‘len’ specified in initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:385: warning: excess elements in union initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:385: warning: (near initialization for ‘uverbs_flow_action_esp_replay[1].<anonymous>’)
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:386: error: unknown field ‘flags’ specified in initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:386: warning: excess elements in union initializer
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:386: warning: (near initialization for ‘uverbs_flow_action_esp_replay[1].<anonymous>’)
> 
> Add the missing braces to fix this.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Presumably also needed for Andrew's gcc-4.4.4.
> 
> Unfortunately I don't know how to fix the remaining warnings:
> 
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:391: warning: initialization from incompatible pointer type
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:408: warning: initialization from incompatible pointer type
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:423: warning: initialization from incompatible pointer type
>     drivers/infiniband/core/uverbs_std_types_flow_action.c:430: warning: initialization from incompatible pointer type
>     drivers/infiniband/core/uverbs_std_types_cq.c:149: warning: initialization from incompatible pointer type
>     drivers/infiniband/core/uverbs_std_types_cq.c:194: warning: initialization from incompatible pointer type
>     drivers/infiniband/core/uverbs_std_types_cq.c:202: warning: initialization from incompatible pointer type
>     drivers/infiniband/core/uverbs_std_types_dm.c:86: warning: initialization from incompatible pointer type
>     drivers/infiniband/core/uverbs_std_types_dm.c:97: warning: initialization from incompatible pointer type
>     drivers/infiniband/core/uverbs_std_types_dm.c:104: warning: initialization from incompatible pointer type
>     drivers/infiniband/core/uverbs_std_types_mr.c:118: warning: initialization from incompatible pointer type
>     drivers/infiniband/core/uverbs_std_types_mr.c:144: warning: initialization from incompatible pointer type
> 
> Smallest variable declaration exposing the problem:
> 
>     static const struct uverbs_method_def bad = {
> 	    .attrs = &(const struct uverbs_attr_def * const []) { }
>     };
> ---
>  drivers/infiniband/core/uverbs_std_types_flow_action.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

I've applied this to for-rc, thanks

I have a notion on how to fix the warnings, maybe you will see that in
4.18..

Jason
