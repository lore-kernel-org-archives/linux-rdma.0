From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next] samples: bpf: Remove bpf_debug macro in favor of bpf_printk
Date: Tue, 18 Jun 2019 16:14:33 -0700
Message-ID: <CAEf4BzYbo2_mTUzBRETecvuofwbDTX-48OEB96OzRMDghrA_6g@mail.gmail.com>
References: <20190618181338.24145-1-mrostecki@opensuse.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190618181338.24145-1-mrostecki@opensuse.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Rostecki <mrostecki@opensuse.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, linux-rdma@vger.kernel.org, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 18, 2019 at 11:13 AM Michal Rostecki <mrostecki@opensuse.org> wrote:
>
> ibumad example was implementing the bpf_debug macro which is exactly the
> same as the bpf_printk macro available in bpf_helpers.h. This change
> makes use of bpf_printk instead of bpf_debug.
>
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  samples/bpf/ibumad_kern.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
>

<snip>
