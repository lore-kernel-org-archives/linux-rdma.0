From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH V2] IB/srp: Fix NULL deref at srp_destroy_qp()
Date: Thu, 11 May 2017 16:06:03 +0000
Message-ID: <1494518760.4024.1.camel@sandisk.com>
References: <1494517956-26669-1-git-send-email-israelr@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1494517956-26669-1-git-send-email-israelr@mellanox.com>
Content-Language: en-US
Content-ID: <D569D4A2597E2640A708677922EA0FAD@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "israelr@mellanox.com" <israelr@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc: "maxg@mellanox.com" <maxg@mellanox.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-05-11 at 18:52 +0300, Israel Rukshin wrote:
> If srp_init_qp() fails at srp_create_ch_ib() then ch->send_cq
> may be NULL.
> Calling directly to ib_destroy_qp() is sufficient because
> no work requests were posted on the created qp.

Reviewed-by: Bart van Assche <bart.vanassche@sandisk.com>=
