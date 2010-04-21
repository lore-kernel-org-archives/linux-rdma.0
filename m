From: Ken Teague <kteague-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
Subject: Re: opensm with multiple IB subnets
Date: Tue, 20 Apr 2010 17:07:02 -0700
Message-ID: <u2q2d0a59b21004201707gecf7f978pa585ada342ccb9b6@mail.gmail.com>
References: <k2s2d0a59b21004201413ia115ae29u661f8df428d5ad08@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <k2s2d0a59b21004201413ia115ae29u661f8df428d5ad08-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 20, 2010 at 2:13 PM, Ken Teague <kteague-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org> wrote:
> I have a 17-node cluster and each node has a single IB card that has
> 2x IB ports (ib0 and ib1).....

After doing a little more research, I confirmed that my understanding
of the manual page is correct. =C2=A0To run opensm for each GUID, I
modified my init script to run a for loop based on the information
returned from "ibstat -p".


I added this near the beginning of the script where the other
environment variables are located:
<snip>
OFA_HOME=3D"/usr/local/sbin"
IBSTAT_BIN=3D"${OFA_HOME}/ibstat"
IBSTAT_ARG=3D"-p"
OPENSM_BIN=3D"${OFA_HOME}/opensm"
OPENSM_ARG=3D"-B -g"
<snip>


I replaced the single line which started opensm with this for loop:
for i in `${IBSTAT_BIN} ${IBSTAT_ARG}`
do
    ${OPENSM_BIN} ${OPENSM_ARG} ${i}
done
<snip>

If anyone has a more elegant way to handle this, I'm open to
suggestions. =C2=A0Many thanks.

Ken
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
