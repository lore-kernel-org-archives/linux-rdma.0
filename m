From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH] ib_srpt: Make compilation with BUG=n proceed
Date: Thu, 17 Nov 2011 15:45:36 -0800
Message-ID: <CAL1RGDV+vgQ7J1VtyeGi-eNw00Bxe35xRJgBu0X4-5PAG4q-nQ@mail.gmail.com>
References: <201111172025.44546.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <201111172025.44546.bvanassche@acm.org>
Sender: linux-next-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org, linux-next@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 17, 2011 at 11:25 AM, Bart Van Assche <bvanassche@acm.org> =
wrote:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_err("%s[%d]: unexpected opcode %d", =
__func__, __LINE__,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0opcode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(true);

Not a big deal, but I guess this could just be

        WARN(1, "unexpected opcode %d", opcode);

etc.

 - R.
