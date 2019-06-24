From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next] samples: bpf: Remove bpf_debug macro in favor of
 bpf_printk
Date: Mon, 24 Jun 2019 16:59:25 +0200
Message-ID: <597ff7f0-8c35-7593-c4e5-dbfa8d0d65b2@iogearbox.net>
References: <20190618181338.24145-1-mrostecki@opensuse.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190618181338.24145-1-mrostecki@opensuse.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Rostecki <mrostecki@opensuse.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Alexei Starovoitov <ast@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 06/18/2019 08:13 PM, Michal Rostecki wrote:
> ibumad example was implementing the bpf_debug macro which is exactly the
> same as the bpf_printk macro available in bpf_helpers.h. This change
> makes use of bpf_printk instead of bpf_debug.
> 
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>

Applied, thanks!
