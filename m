From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: Setting QP attributes with RDMA CM
Date: Wed, 03 Mar 2010 18:31:19 +0200
Message-ID: <4B8E8ED7.204@Voltaire.com>
References: <4B8E8D7B.6030508@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B8E8D7B.6030508-YJJp1DzrooEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Todd Strader <tstrader-YJJp1DzrooEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Todd Strader wrote:
> I'm using the RDMA CM to set up a QP and I'm trying to figure out if I
> can suggest QP attributes to it before it transitions through all the states

see rdma_connect(3)

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
