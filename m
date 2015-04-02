From: Roland Dreier <roland@purestorage.com>
Subject: Re: CVE-2014-8159 kernel: infiniband: uverbs: unprotected physical
 memory access
Date: Thu, 2 Apr 2015 09:32:56 -0700
Message-ID: <CAL1RGDWtbEzepxbmHUzteJ-+dcW=VxmTshGzsSN219Tgx3bMvQ@mail.gmail.com>
References: <AM3PR05MB0935AABF569F15EA846B8E72DC000@AM3PR05MB0935.eurprd05.prod.outlook.com>
 <CAL1RGDXQh2+WQxf9w2Qvo-Npr2MnBZYObyfYfy7fn-Pfue=Odg@mail.gmail.com> <AM3PR05MB0935CC450033AE6DFF0B14B3DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <AM3PR05MB0935CC450033AE6DFF0B14B3DCF20@AM3PR05MB0935.eurprd05.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Shachar Raindel <raindel@mellanox.com>
Cc: "oss-security@lists.openwall.com" <oss-security@lists.openwall.com>, "<linux-rdma@vger.kernel.org> (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 2, 2015 at 12:52 AM, Shachar Raindel <raindel@mellanox.com> wrote:
> This is a common practice in the security industry, called
> "responsible disclosure."
>
> Following the kernel  security bugs policy [1], we reported it to
> the kernel security contacts few days before making the issue public.
> Few days after issue became public, we published a clear report to all
> of the relevant mailing lists.

Isn't the point of responsible disclosure to delay disclosure until a
fix is in place?  What's the point of sending a notification to the
kernel security team if you're going to disclose publicly before the
upstream kernel is fixed?

 - R.
