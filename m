From: "Joel Nider" <JOELN-7z/5BgaJwgfQT0dZR+AlfA@public.gmane.org>
Subject: RE: ib_create_qp failing
Date: Mon, 29 Jan 2018 22:18:06 +0200
Message-ID: <OF09394B7D.58CD59F8-ONC2258224.006BDAF8-C2258224.006F854D@notes.na.collabserv.com>
References: <OF089AD255.99D19AC9-ONC2258224.002F8CF2-C2258224.00309558@notes.na.collabserv.com>
 <AM4PR0501MB27239EF18E2C07A64B045674D4E50@AM4PR0501MB2723.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM4PR0501MB27239EF18E2C07A64B045674D4E50-dp/nxUn679gUhbbWvQuVF8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ilya,

I am using ConnectX5 EN with special firmware (I just mention it so you 
know, but I'm pretty sure that's not the problem).  I have used dynamic 
debug - it shows me that the call is failing like this:

mlx5_core 0000:01:00.0: mlx5_cmd_check:714:(pid 120772): CREATE_QP(0x500) 
op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x48b5c0)

Is there any way for me to look up the syndrome?

Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote on 29/01/2018 21:04:57:
> > 
> > I have used the net/smc module extensively as a reference, but there 
seems
> > to be something fundamental that I'm missing.  How can I find out 
what's
> > going wrong here?
> 
> Hi Joel,
> What ROCE device are you using?
> There are many debug prints in the Mellanox drivers.
> You should try enabling  dynamic debug for mlx4_ib or mlx5_ib, it might 
give 
> you more information.
> 
> Good luck,
> Ilya
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
