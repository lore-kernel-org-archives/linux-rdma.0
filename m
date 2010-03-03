From: Todd Strader <tstrader-YJJp1DzrooEAvxtiuMwx3w@public.gmane.org>
Subject: Setting QP attributes with RDMA CM
Date: Wed, 03 Mar 2010 10:25:31 -0600
Message-ID: <4B8E8D7B.6030508@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I'm using the RDMA CM to set up a QP and I'm trying to figure out if I 
can suggest QP attributes to it before it transitions through all the 
states.  My QP is coming up with rnr_retry = 0, and I'd like to set it 
higher.  Is there any way to do this besides going back through RTR -> RTS?

Also, if this isn't the right place for this discussion, can someone 
point me in the right direction?  The openfabrics.org lists seem to be dead.

Thanks.

Todd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
