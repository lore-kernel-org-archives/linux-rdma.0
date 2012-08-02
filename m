From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: FDR HCA only doing QDR?
Date: Thu, 2 Aug 2012 13:19:55 +0300
Message-ID: <20120802101955.GD3374@calypso>
References: <CALfB72AFcWfrvRHfh0fRu_0iLt0wdapgwPef6RFe3KockzxeEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALfB72AFcWfrvRHfh0fRu_0iLt0wdapgwPef6RFe3KockzxeEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Albert,

On 10:18 Thu 02 Aug     , Albert Strasheim wrote:
> Hello all
> 
> I have a single machine setup with a dual port Mellanox FDR controller
> with a cable marked "FDR" connected between the two ports.
> 
> OpenSM is running on the machine to make the ports active.
> 
> However, as far as I can read the ibv_devinfo output, it seems to
> report that I'm only getting QDR speeds.
> 

You can double check the speeds by running smpquery PortInfo/MlnxExtPortInfo

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
