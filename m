From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH V2 18/22] bnxt_re: Support for DCB
Date: Sat, 10 Dec 2016 15:50:25 +0200
Message-ID: <CAJ3xEMjcKRZpBMEBwQMZO5OqbVzH2=Q3FOAyYUVAz+ouw1jTNQ@mail.gmail.com>
References: <1481266096-23331-1-git-send-email-selvin.xavier@broadcom.com> <1481266096-23331-19-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1481266096-23331-19-git-send-email-selvin.xavier@broadcom.com>
Sender: netdev-owner@vger.kernel.org
To: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linux Netdev List <netdev@vger.kernel.org>, Eddie Wai <eddie.wai@broadcom.com>, Devesh Sharma <devesh.sharma@broadcom.com>, Somnath Kotur <somnath.kotur@broadcom.com>, Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 9, 2016 at 8:48 AM, Selvin Xavier
<selvin.xavier@broadcom.com> wrote:
> This patch queries the configured RoCE APP Priority on the host
> using the dcbnl API and programs the RoCE FW with the corresponding
> Traffic Class(es) for the priority.

> +#define BNXT_RE_ROCE_V1_ETH_TYPE       0x8915
> +#define BNXT_RE_ROCE_V2_PORT_NO                4791

I believe these two are defined already, try # git grep on each under include
