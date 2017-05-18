(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[�/�$!�:���Q����u|���`�_>H�&�W�&���;|Aq�q��0�������Ӝ��dk;�վ�S{;�^.�Z�?�#�'��v��^N�z/��˟�	��xM��)����!�U�/o����;����G�"��	�P�wo{�{�h�\�Z��r�K���l��+�r��4MW�/��5��N�;�����q0Ew�~z-�=�h, (J҅�����<��8^���k��P|������E0��pʦ\�F�9��됄�{.�P������4E2�k;E�(����}�ث�s�!������?N���?^|��RC��?\�_��Y������.��km�:�AJ��&���ĻlR_�L~o�Q�k�VCٴ��MfBj��|����F_!X�b3h�q<u��ؤ������D�)�F=D!���t��S�N'[	��n C�T��>am�}yq �HqՏl���_�k߾A�Ɗ���c�������Eӥ��;���FU�����qu|{��у{�����b��O ��/�?/�,�|�6o5�,�M���A.s �5e)�ɬ�m�!ǳ�Rܶ���\�&�Y��i�q��e9�k�`jZC�[�� Jq#�D�S�&e�p�u#2�q�p�)��)� �6�8�C֐��#u�D]���Ev����A܉�q�jr@1�&��Z=7rw
G� �qEPr�x=X�b�#���4y���rK;
��[0Qx�Tv��й������i,"om졸�f`p�s�,�\Í���-�ܷ
�@��Y����_1��㡹7��R1���)n�M�'
�No

�8�WňP�<�9���n$�)a7�a/�-��bc���9}���)�h'�rVr�P����]i�Y&n��Vw�t3עf��)�8>�'�"�xy2�S4�E������5���'�K
P80y�(r�r�,��t�1)m�&Fv��Ê	��R=0�6H�\�h�D�i��&C!J !P�/k<y:9�����	t	#.b�fu0���n����ڹr�Iڒ�hj�x1��C&K f�ȱh�sfы��(�e��F��=3��/��l������(^�)� �?Jj����S����%��������'����G�y��S��]��H��9Zr;ˇr$��B?b�K����P�I9�S�bqU0U��"��~�Wf�}�"�;� Z�XX���+9$�MY���q��h1Qt+��)�)�a�P_�&N�&.�n��s����2�M���4���j�vZ�b�w� 4��[�.u��z��3w�V�J�Bx��К0
�-�G�H�-MSΌ�5 �$./�@���y����*�q���1�����8�t�܇�.��w|K3ymJ
�(�Hs?4���\rآQ��R�l�9��L�k|'p$�,���&��/�D�0����t��<�1>�@��亖L��)�fV}ȡ�a��?�����k���������?J����g������]���K@��W�������/��7�^��D���2�K�������+U�O�����):�I#������8E�ů�4e�"����Q~�d�b4�z�W���](C���?���������?|�'��&�<i�'�ˬ�YB�+<�8�0��(�������ll��m3b2n�I���-�/�eK֓�9�6��s�i��nG�sln���_n�ۭ �Q���R��a��^�������*��|��?<����������j��Z�{��������K���Q�G��T�_9x[�����{3��#�C��)���h��t��>����c����f�M���� ���&s�;P�\��#�.�CL2����ܚ�=���a�|�P��I��N���lXo&�w�A�1hJ�x\LХ7(w�j��1<tO��1G�������t���stNnq���,�2�s����g�@[���`%N��;���g�m��I��(/�A���{�?-L{�dЄ�NSD�>�1�?��h�������Np���Y�3�ei��@y��1�TpD	i'b$�#�����HȜ'pr�CZ�?�����g�����������Pt������+�����\{���ߵ�}����"h������B�/�b�?�U�_
*������?����?�zl h��T�e����t���GC�'��]����p����-x�a	�DX�qX$@H�Ei�$)�����P��/��Ch��2pA��ʄ]�_�V�byñ9�5�f{�9Ҫ�l�m��Rx1�%���q�N+)54$wm'���ǫ{���(ǌ��v��7pD���������=n2�L?�SJN�v�*���x<�����?�b���j���A���y
�;�����rp��o__�.�?N���/����ۗ/+���O�8Qɿ|��_�z��qC�����wX��p���O�Z�)�2�Y���ň��ǶI��)�B]�B<�`Y�����w]7��%� p|�eX��JC�|�G��?U�?�������Aj�h�(��P�A����0�.���]#M���/���4���v]wW����s)���aDn5f����Q�5#���n��������j=qMP��	ff�^���9�_�����*����JO�?
�+��|���}i�P�2Q��_��P�|�M X�������1��㿟��9+9�Vᯱ�% ��7�g�?�g}��$������7����*-û���֍��{�� �7�ݰ����s��Mk?lڹe�@��S���)�b^<�]h�i���Mb�ڷ�M�	l#ע�iV��X�g�����z�N��7o�(6W3����V\4�ߛ��
�[g���|�G�-ãe�q�#=�$l��v�$�\h���@8ǻ5u�\�(R�&���t�*�)�sj�N%��ǆĭ�0����@ u�3"�mo�ey����A�Ě@�D0�ljN�����|sO���F���4�r�Yf<%���?m{�ȡ��<wJl���'�M�V������Z���"k�JC�y�`��_����+����?�W��߄ϙ�?ȭ܀�e��U����O�\��%�m�?���?�m�a��o��N2;M�p�g�?���qo(�g���@y�@wA޺d�d����5`�5M|��?�O΃���ɡ���-*�;��5Y/��Z�o�JOM���C|k�r�Z��0�SٌI2��u��(�Z"��r��դ��y��!�~��܇.���� ��Y>h��@�Dk�<�w�u7��+e0��j.uq�?%s9��V{f��!Wk����=h�t�0B��G�P��a�?������/q����T�W
~��|�Q��)	�1����ʐ�{�����Y����j��Z�������7��w�s���aX�����r�_n�]��U����T�_���.���?����S}�[)���	��i�P��"Y�eh��(�	�	� �]�}�pȀ�� �}�r]�q�N���P��_��~t�IW�?����?@i��-'�}˜�1lv�C���s�`�����GڢEM^��c�9��v�u%���Qt/YS\��A@����X�%5�Zߺ�#j��������pF�ehr��Lo�W�(�M{h^��y/�؝�i1��$���}���{�|���lz���������f���Z���2?�N]?�
�j��/��4�C�km�O�t�{a1�I��k�1�E\���5re/��}����N�x�����Z��&N���4�����.��Z�������8]g���������Ҋ��K�k-�Ԯ��_O�Ż�])��Պ`��k����yh�:����e�|��y�+�v�`���7���]y�.�ƋM�?�k��Sݾ��)n�{���K?�Y�Q1*\��2�(pk+܎����r_V��.[]]uQ�i�����MG��
A��o�������k_�+���
ߎ�}��$w~0������<��0��}�kgQ�ٗ��AG��d�[����ͫ�Yނ(K��+0:���o��X<���^~�c�[&-����֋{����8C~Z�����ͷ�֦w������������3�X��W[ ����ߩ�y�Χ��ƛ�_kp���0N���R���ƹ.T���#��k���O4a���"D~��j��Ծ���}�������,n{����S�+��X�"��wu�oY廂x#�D~`����݁�=Z �˪����N7��dS)���ʪ�m����0<��5��S8�,�%u�=��O��b�S���=��{W�:Y��r���C	r9�e�p1�x��CE�n�v�n��7%מ�k�ukO�wb��L|	�7	!~ b������E��"h0ĈBL�h�m=��v���pA�s�{��������{����<�^l2�1F69_�)7�2�B�Y"� c���.������d&K]J�#�0�[۲vL@u�$uD���e8���V��i90���Xti1 ��f��O�9���mB�%�b¸�;�"�ʒ$�tpph|�m�5\����pr��5�!��L�nV)��8Z|ۀ��"&Y2b��h�n�ڨ�;VIp�><άW��w(IP�}F���H�t[��i��-���K��v��;ĻY�3n��2�`�g.��2{hJ#��U)�j�A�a�e����;��Cn��/��
��vI�Э����1�"���`��"yߢ�2@��S�(p�4��6�N}sp��/��������Ofw��h1�N�.�������U�*�z�̅��3���<'�Z����:��ӿ�e�M$�TҀő*�����#�é�e�猞N���"�9�eDi�ssW�kF���we>�W��k�ZS�*��n�9H3���E��ں��.2Y��<+e���)]����{�*wQ�h.P��Q�$
l����7��\sB�VWn�3Bs2��#���\���3�:�d4[PN�+�b��9���s�5D7r�I��6�sR�u�B��x���X��u��e���ۜ�i���i����Z;��O����\-VF�����l���ZT��ۅ�]��v�}�`�ՙ;pr*_ѫ��~8�4��F��QD��
���?�|@������V��q��d���?��������O��8x�Nl�Z{�ߏ��j絖J\x`���.��@�`,��E�U�uc�^�G�׳��V]����*���#��C9=�����Cgoo�vǙ_���ح��wO<����ڥG��9�
<C��J7����9�5�@8�C'��� ��š����9p�q��9���'��\���H�A���>=�Ծ�_���d}����Y�<0"�Ὠ�%�,ף��m��$^�0{����� ��a���6���e�z�����`#G$7C�6�%�n�3�,�Q��!�n�_��[��!��L��P;e��k`�4��Wɝ.��i2_�Q,S�׃���l���A�#pF��Ɇn�R�$�l����0GaJ����&j|?Mg��hG�X�)�A�/�����,
�L:;�+��f�(�ȄT*{j�l�G	�F)/�0,��-!&$=���,$�������C|��Ԕ'��z)D�!X.�G>e3am&�̈́]�	=} �n����E��Ԧ�:�Z�z�C�kvzK�.�����JȺUq0���h��d#n<(owœ�LR�n��2W��p_�#^���2A4�'Q��o5z��	%�L��6��|B"��CV�v�4�.�`�A"ԎdX��������+�CV�ل��l����A�
Amk�r<B�S�H��j���q�d%�U:�>�v�j�����D�@�)�apw=��cLd�m4�}e	��,ـuFY�ܙ�\w@
d���p*%����N488�������g�V4�v��6����P>�S-�IqJt���/B��ʠ
����g$:�%*B��*�h��1y<ӒRsʲGxFv��DU��h�7$	����V��9�`W'���p�I�8b*�`X-�;Q����J%#5?�k2�|�PM�}����
�ﭲ�)K����W��
�Ec=��|���Q�t�Y $(q����;)t�Z3�]���_I�|/5,��q%Z��vr�İR�������HLj�	 '܇S����I�A��j�,��7¤\�L�c�9e�#<#�TY��&��0��Ū�>-�T�{�,�+�k�%��7�p�9D���I��ɾ�T�6!�}�B�3#٤Ȗ#� ��$�����8m����l�m5�m�n�4'
�)��6�j�G�skWB�tJ�{b튍3�uӯ�V&A �.{�T�u��t��+��J�l�PUm���mN4B�r��]�v{]M���!T�����7�n�n7��+m\�F'7�7��B���j����AkSU]O�g���Ѳ��֡S�&K�%�ך��Ԇ<t3tz�?��s�هvX��:�,tf�*L~���d.��0�J���r��z]�Z�qL�gu�%3>1-3y��ʁ�;N㊢�Ũ�g�C/CF`Ō�C�C�.��DY5>�i�: �ڌ��?�#�_�[�ȍ������[����w˳_
엂�_
?p�-<���[$��3�.V�|+���le��}�AK	����Xt0�梃Ѡd�AO���`iς�Gu��I���iL7k� �=�w�{�1��7=4E��!�)5�Eҫz؈�EX)�E�@8R����hőh��~����WH�n!8�Ŕ�h^wn�u:�q%_�8Vh�c�rhd�:�����ᑠ�6���ӘI��ݣ&�C�±DM�05:D��g���ꪷC�fj9�i�:F��|>��O(�*q�2��T�q6�AZ��se�u�7�76���6D;�O�bB�%�[$��yյn��i
�$u�-��r�ǥ�V�c<��q8m㰍�6��X׮�t7t��T�2�\�6���c2�c�3���<�{�;t�[�2\��2����}���^���1�������ܗ�ò#i�Hڪ�Hf*8�6J�J)7p�K2�:�e؜�|�����b�KQ���`��>��D�Q�"�V�QPd�YS�՟c�w��Fm*	LL);q1D�A0�L��Ni��r&��tP8��Ѳ��/+]n�4��������/
�K)	�bB8Z��썅��Cvc!D����A���0!RcKM���pp�(O���nAy��._ڙ�+�Ŷ;"��|��R<���Byq�Y&�P�l�3� BW��B{���Ė��9@7Y����R.��t���V/�¾K;��a��a���q��q�F�Vr�܇v�fr��Z)$�B�m�"��ۅ�6e5��2m�õ;�-\���n�_G4�JE�5���^�\?���σ�q��$��-�M����Lw{}�\�W�Mҟ�I�t���^���G~��V�;>��/륧��]_z�/���q�Zc?�������f�ٴp��1�q ���]������%���g����Ko��� �x���M|󦿾��W�? z�$��8x*�~p�ڕޯ��䊞n��h:Q�m@g߈��O~�/6~'����_/��׿�'��)�����4E�|�	�9K�|զv��N��i�l��M����߿��i; mS;mj�M��}6�g{?P;ͷ��|�� U�B����z��&�&�A�-"�N21����L��1��=��_��^��&��<ۭ�y��T�S��3���6���gp��X���`9_�MM�Y�i�sf�h�=gƞ`O�����a�e�3s���G�s9f�\8�0�!Bk��6�]��1�9��_ju��b��Nv������M�;}l	  