From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [opensm] [PATCH 1/5] Free memory from osm_subn_opt_t when
 osm_subn_t destroyed
Date: Tue, 15 Nov 2011 08:10:28 +0100
Message-ID: <CAO+b5-p5RUf502NYBS=q9ot75qo8s_+v0GOEviJZpmhm-qmSGQ@mail.gmail.com>
References: <1321310989.5518.50.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321310989.5518.50.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 14, 2011 at 11:49 PM, Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:
> + =A0 =A0 =A0 if (opt->vlarb_high)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 free(opt->vlarb_high);

Those if-statements are superfluous - invoking free(NULL) is safe. See
e.g. http://pubs.opengroup.org/onlinepubs/009695399/functions/free.html=
=2E

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
